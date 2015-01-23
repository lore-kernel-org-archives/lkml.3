Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbbAWBTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:19:41 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35857 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbAWBTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:19:38 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMh1HE+hMP0VWr2vaHCp2itVjpQeiiFL6r9WeJUFes5tvw@mail.gmail.com>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
	<1407202310-3359-9-git-send-email-sboyd@codeaurora.org>
	<CAOesGMh1HE+hMP0VWr2vaHCp2itVjpQeiiFL6r9WeJUFes5tvw@mail.gmail.com>
Date: Thu, 22 Jan 2015 20:19:37 -0500
Message-ID: <CAF6AEGs3058dj7f06qvngOaBPiuJn4QrYFKQD-RQV4ydZ1h2sw@mail.gmail.com>
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
From: Rob Clark <robdclark@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lina Iyer <lina.iyer@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 8:13 PM, Olof Johansson <olof@lixom.net> wrote:
> I just saw this in the pull request from Kumar, so this is a bit late
> w.r.t. to the patch, but so was his merging of the code. :)
>
>
>
> On Mon, Aug 4, 2014 at 6:31 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> Architectural changes in the ARM Linux kernel tree mandate
>> the eventual removal of the mach-* directories. Move the
>> scm driver to drivers/soc/qcom and the scm header to
>> include/soc/qcom to support that removal.
>
> The idea is not blindly move one dumping ground to a new place.
>
> I see only two exported functions from scm.c:
>
> scm_get_version: This is not used anywhere in the kernel and can just be removed
> scm_call: This is used by scm-boot, and would be better to translate
> over to firmware_ops in the first place.
>
>
> So, can you please rework this with the above in mind instead of just
> moving the files over? Thanks!
>


jfyi, we have some pending drm/msm patches blocked on this move

(not trying to comment one way or another on whether all or some
should be moved..  just pointing out there would be more in-tree users
of it if it was moved)

BR,
-R

>
> -Olof
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
