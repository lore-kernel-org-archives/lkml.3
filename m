Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618Ab3JPVtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:49:07 -0400
Received: from smtp105.biz.mail.ne1.yahoo.com ([98.138.207.12]:36070 "HELO
	smtp105.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761477Ab3JPVtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:49:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3oW17ZkVM1kdTrK8ihMBNzC9KoAV77ckS.9c7gD2iHBnATc
 b3t0wejOAbSVWdWEIB_dtY8cC3ziVjyJZdqIKZhWpwUwWQprl0CX1z7rSKrR
 a5n7S9SP0qFkYLoWVu4I7rmOxBpnfThu09TixPYNboS7d.1yBX5JUCFkHHvm
 M1DLdNhSMvNsDQvCcUrsPeyUCT7Q343f2xvpaI_StNDQFJijTXsX84iq3Ot1
 GluqsbdW3G_Mkxw1VyjtdtbdQZhYPQVATDouecSVVfh5VVlYWQK_hdbbQjGX
 chFpW0Ik5IgtktEg0.HM4fb5XlGpp28SsOyHw1zDgJcI_Ql9NfzSV4Q__Ebr
 UjvycQDnQZP6pnp3anE2dZoAWLy4jI2gy8qOzifRoYNpimaESAKWPzbHhwdt
 gKqhxyY9p.2WSgDrzRM452w61ulEa0gAzGmkOj9alZ3azUaTF7mAEEWC_SPd
 QFUPZyoPWRMc6QjSruMHKIacpiTycofss6GiLJ66E4rW42KadpNC8AhjuW76
 Z7hp6N6Nb6TmPZKCNZn.OiIMkRlvjOrEJY9P3.pXAZF9G0m0N
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.168.21.102 with )
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 16 Oct 2013 14:42:20 -0700 PDT
Message-ID: <525F083D.8060502@schaufler-ca.com>
Date: Wed, 16 Oct 2013 14:42:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
        james.l.morris@oracle.com
CC: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
References: <20130920203556.GA8726@www.outflux.net>	<alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>	<alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>	<CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>	<20131016151831.GE5186@outflux.net> <201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>
In-Reply-To: <201310170547.EHH26015.QOtHJOLFOFVMSF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 1:47 PM, Tetsuo Handa wrote:
> Kees Cook wrote:
>> Any update on this? It'd be nice to have it in linux-next.
> What was the conclusion at LSS about multiple concurrent LSM support?
> If we agreed to merge multiple concurrent LSM support, there will be nothing to
> prevent this module from merging.
>
Yeah.

The conclusion was that it needs to be staged because it's
too much to swallow all at once. I can see that. It's going
to be a lot of work to rearrange and rebase. That's a chunk
of time I don't expect to have for a while. It looks good
to happen, but don't hold supper for me.

