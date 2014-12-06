Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaLFEff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:35:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:52745 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaLFEfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:35:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425801221"
Message-ID: <548286EA.6000402@intel.com>
Date: Sat, 06 Dec 2014 12:32:42 +0800
From: Jike Song <jike.song@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Li, Susie" <susie.li@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        linux-kernel@vger.kernel.org, "Haron, Sandra" <sandra.haron@intel.com>
Subject: Re: [Intel-gfx] [ANNOUNCE][RFC] KVMGT - the implementation of Intel
 GVT-g(full GPU virtualization) for KVM
References: <547FC5DE.4010701@intel.com> <1417769421.11297.37.camel@nilsson.home.kraxel.org> <20141205135418.GL20350@phenom.ffwll.local>
In-Reply-To: <20141205135418.GL20350@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 09:54 PM, Daniel Vetter wrote:
> Yeah done a quick read-through of just the i915 bits too, same comment. I
> guess this is just the first RFC and the redesign we've discussed about
> already with xengt is in progress somewhere?

Yes, it's marching on with Xen now. The KVM implementation is
currently not even feature complete - we still have PPGTT missing.


>
> Thanks, Daniel
>

--
Thanks,
Jike
