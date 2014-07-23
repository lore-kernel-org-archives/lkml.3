Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbaGWPgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:36:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53163 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150AbaGWPgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:36:44 -0400
Date: Wed, 23 Jul 2014 08:37:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
Message-ID: <20140723083759.6b730d67@jbarnes-desktop>
In-Reply-To: <CAKMK7uG-zX2ZDSoQ+XmXOvUeAZzvbdsv02+fX47uJUt=21cRaQ@mail.gmail.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<53CE6FB0.90500@canonical.com>
	<53CE7410.3090603@amd.com>
	<53CE74B5.3000201@canonical.com>
	<53CE77B4.6020801@amd.com>
	<CAKMK7uESXrDtCov8whOTsffg6eZdibF4qaTFaCubM=mnhN=gNQ@mail.gmail.com>
	<CADnq5_Moy78A5JfDM0LME6_-48PW72DJpYYvEthQ5b=_amU8KQ@mail.gmail.com>
	<CAKMK7uGtfUTU=VwSnF07jncJsH1Ckie2m1FCjct60Yz88uE3cg@mail.gmail.com>
	<20140722121435.6bd093d0@jbarnes-desktop>
	<CAKMK7uG-zX2ZDSoQ+XmXOvUeAZzvbdsv02+fX47uJUt=21cRaQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 11:47:15 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Jul 22, 2014 at 9:14 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >> We don't have the code yet ready, but that's the direction i915 will
> >> move towards for the near future. Jesse is working on some patches
> >> already.
> >
> > Yeah I'd like to get some feedback from Maarten on my bits so I can get
> > them ready for upstream.  I still need to add documentation and tests,
> > but I'd like to make sure the interfaces and internals get acked first.
> 
> Review works better if you supply a pointer to the patches ;-) I asked
> Maarten whether he looked at it and he said he didn't know where ...

Oh I provided it in IRC earlier, figured Maarten was just busy. :)

Tree is android-dma-buf-i915-fences in my fdo linux repo.

-- 
Jesse Barnes, Intel Open Source Technology Center
