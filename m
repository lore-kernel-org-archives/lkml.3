Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKUS0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:26:09 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:39224 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaKUSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:25:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141121181332.GY3815@sirena.org.uk>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
	<1416512485-7292-4-git-send-email-joshc@codeaurora.org>
	<20141121181332.GY3815@sirena.org.uk>
Date: Fri, 21 Nov 2014 10:25:48 -0800
Message-ID: <CAJAp7OhY2pz+ppjbYRrjZ2E3Bn9NM54dfs1=xoqxd5tG5e3WaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: rpm: add support for RPM-controller SMB208
From: Bjorn Andersson <bjorn@kryo.se>
To: Mark Brown <broonie@kernel.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:13 AM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Nov 20, 2014 at 01:41:25PM -0600, Josh Cartwright wrote:
>> The IPQ8064 reference boards make use of SMB208 regulators which are
>> controlled by RPM.  Implement support for these regulators in the RPM
>> regulator driver.
>
> I'm missing both patches 1-3 and the cover letter, what's the story
> with the series - are there interdependencies?

Hi Mark,

There are no new dependencies introduced here, patch 1 and 2 are DT
and mfd additions. So you can apply this patch independently in your
tree.

Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

Regards,
Bjorn
