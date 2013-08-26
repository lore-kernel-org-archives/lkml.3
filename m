Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3HZShp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:37:45 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62622 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3HZShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:37:43 -0400
Message-ID: <521BA070.2000800@gmail.com>
Date: Mon, 26 Aug 2013 20:37:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com, tomasz.figa@gmail.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/5] ARM: samsung: add clock setup for FIMC and FIMD
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com> <1377517114-20222-4-git-send-email-m.krawczuk@partner.samsung.com> <1445676.NMCyFEC5q4@amdc1032>
In-Reply-To: <1445676.NMCyFEC5q4@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(dropping linux-doc mailing list from Cc)

On 08/26/2013 06:19 PM, Bartlomiej Zolnierkiewicz wrote:
> On Monday, August 26, 2013 01:38:32 PM Mateusz Krawczuk wrote:
>> This patch adds code that sets correct parents and rates for clocks
>> used by FIMC and FIMD on Goni board.

This patch is supposed to be a workaround to make the display and camera
subsystem working even without properly configured parent clocks in the
boot-loader, right ? And as such it doesn't really belong to this series
and has been written primarily for the clocks testing purposes ?
I think it can be dropped in the next iteration of this series.

--
Thanks,
Sylwester
