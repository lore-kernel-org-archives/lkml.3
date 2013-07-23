Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3GWD10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:27:26 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:50621 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3GWD1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <E1V1Nm3-000740-TB@jdl.com>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	<1374290388-19308-3-git-send-email-grant.likely@linaro.org>
	<51EC2EC7.6010001@gmail.com>
	<CACxGe6sGdkMuLFs3K_ERKot+ryTArs6qTiwpXNe+LyoAQ8HGDw@mail.gmail.com>
	<51ED9694.9060303@gmail.com>
	<E1V1Nm3-000740-TB@jdl.com>
Date: Mon, 22 Jul 2013 22:27:23 -0500
Message-ID: <CAL_JsqK0SVS+odf-7ZW6ETS7W8q4ZW1i9WQUGOJuG2Jmyph+-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Rob Herring <robherring2@gmail.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 4:36 PM, Jon Loeliger <jdl@jdl.com> wrote:
>>
>> My own selfish desire is to easily separate emails for DT bindings and
>> DT core code. I suppose I could do that with a suffix on my email address.
>
> And I've had the reverse problem:  Sorting out the DTC
> and libfdt patches from the noise. :-)

Noise to you is rock-n-roll to me. ;) It's only going to get harder if
lots of email to devicetree-discuss was getting dropped waiting for
moderator approval.

Yours is the harder problem since there is not really a way to use
kernel MAINTAINERS for dtc. Perhaps the kernel maintainer for dtc
could be "Send Your Patch Upstream <nobody@nowhere.com>".

Rob
