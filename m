Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaEMQrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:47:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:1826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaEMQqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="539703919"
Date: Tue, 13 May 2014 17:46:31 +0100
From: Damien Lespiau <damien.lespiau@intel.com>
To: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140513164631.GA16632@strange.amr.corp.intel.com>
References: <20140509170335.GZ18465@intel.com>
 <CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
 <CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
 <CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
 <20140512190300.GF25056@phenom.ffwll.local>
 <CADDKRnAOkdaziCQ_NGkt01hiQqjiAiKza2+QbCuDBuY72LJK=A@mail.gmail.com>
 <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
 <20140513132200.GC3908@phenom.ffwll.local>
 <CADDKRnADucv7wMRgEDZ_DKRJqkPPZdgymL6VJhtG_JD9MkiJhA@mail.gmail.com>
 <20140513163832.GM3908@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513163832.GM3908@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 06:38:32PM +0200, Daniel Vetter wrote:
> > Doesn't work for me, I still have an underrun at boot-up.
> 
> I'm at a loss tbh with ideas. We successfully disable both pipes, then
> enable pipe A and it all works.
> 
> Then we enable pipe B and _both_ pipes underrun immediately afterwards.
> Really strange. Can you please reproduce the issue again on
> drm-intel-nightly (latest -nightly should also have the display
> corruptions fixed, so good to retest anyway) and attach a new dmesg with
> drm.debug=0xe.
> 
> Meanwhile I'll try to come up with new theories and ideas.

I do remember a reporter saying a BIOS upgrade fixed that for him. This
is one of the reasons Paulo put that BIOS update message.

It's worth the try if you ask me (the BIOS update will bring new memory
latency values).

-- 
Damien
