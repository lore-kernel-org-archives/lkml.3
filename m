Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab3LFOvD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:51:03 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:55142 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3LFOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:51:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Dec 2013 15:57:14 +0100
From: Stefan Agner <stefan@agner.ch>
To: Mark Brown <broonie@kernel.org>, lee.jones@linaro.org
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lgirdwood@gmail.com, kai.poggensee@avionic-design.de,
        sameo@linux.intel.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] regulator: tps6586x: add and use correct voltage
 table
In-Reply-To: <20131206125502.GF29268@sirena.org.uk>
References: <cover.1386333697.git.stefan@agner.ch>
 <7c948660cda4684d28fa97f82295ab84f6ef658e.1386333697.git.stefan@agner.ch>
 <20131206125502.GF29268@sirena.org.uk>
Message-ID: <102f036079d68c84b87ec30a6566bb21@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-12-06 13:55, schrieb Mark Brown:
> On Fri, Dec 06, 2013 at 01:51:46PM +0100, Stefan Agner wrote:
>> Depending on the regulator version, the voltage table might be
>> different. Use version specific regulator tables in order to select
>> correct voltage table. For the following regulator versions different
>> voltage tables are now used:
> 
> I think this is the same as the last patch I reviewed but I don't see my
> ack on it?

Oh sorry, its my first multi-revision submission. I didn't realized that
it is my job to add them when doing a new revision... Lee, can you add
that when you apply the patch? So far I see

Acked-by: Mark Brown <broonie@linaro.org>
Reviewed-by: Thierry Reding <treding@nvidia.com>

for this patch.
