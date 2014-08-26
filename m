Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaHZRky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 13:40:54 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:13762 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaHZRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 13:40:53 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-LoopCount0:X-IronPort-AV:Message-ID:Date:From:
   Organization:User-Agent:MIME-Version:To:CC:Subject:
   References:In-Reply-To:Content-Type:
   Content-Transfer-Encoding;
  b=HQTuL2ixa52FqMK3AmGFFnPUcIbudag9Gf1jIjY6BlqGUs3YuEa4uOSF
   8NY6poV98Xvgh+NWb0Jyl/1uku5/zDbpWt3ulBLV4SP1kS4cL0kF55JuI
   IA90TcwEM7BE8ZfpdtzVGT96kvyoMdUe4h/6SAMenNmP8DuAMzJrbLG+E
   M=;
X-LoopCount0: from 10.208.46.70
X-IronPort-AV: E=Sophos;i="5.04,405,1406610000"; 
   d="scan'208";a="559113438"
Message-ID: <53FCC685.8060305@dell.com>
Date: Tue, 26 Aug 2014 12:40:21 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
Organization: Dell Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, "Luis R. Rodriguez" <mcgrof@suse.com>
CC: Abhay Salunke <abhay_salunke@dell.com>,
        =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOt?= =?UTF-8?B?Z3Vleg==?= 
	<crrodriguez@opensuse.org>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        "Hayes, Stuart" <Stuart_Hayes@dell.com>,
        "Singh, B B" <B_B_Singh@dell.com>
Subject: Re: dell rbu driver and FW_LOADER_USER_HELPER
References: <20140826170946.GP3347@wotan.suse.de> <20140826171425.GQ3347@wotan.suse.de> <CAG-2HqULGgC5ftNKOML4XJZ5v_1b+z0t92nctTh7RB2tniRb9Q@mail.gmail.com>
In-Reply-To: <CAG-2HqULGgC5ftNKOML4XJZ5v_1b+z0t92nctTh7RB2tniRb9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/26/2014 12:20 PM, Tom Gundersen wrote:
> On Tue, Aug 26, 2014 at 7:14 PM, Luis R. Rodriguez<mcgrof@suse.com>  wrote:
> The rework is now upstream, but not yet released [1].
>
> The dell driver dose not use rely on udev in userspace, nor the
> /lib/firmware path. It has its own userspace component, which just
> happens to reuse some of the infrastructure the udev firmware helper
> used to use. This has now been split up, and as of 3.17 the firmware
> loader can safely be removed from udev.
>
> [1]:<http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5a1379e8748a5cfa3eb068f812d61bde849ef76c>
Loop in Stuart Hayes and BB Singh.  RBU support is primarily used/supported on poweredge today, and they should be able to help comment and sort this out.
