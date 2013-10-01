Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3JAO77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:59:59 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:35510 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3JAO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <20131001092258.GJ19304@sirena.org.uk>
References: <1380600664-20649-1-git-send-email-badarkhe.manish@gmail.com>
	<20131001092258.GJ19304@sirena.org.uk>
Date: Tue, 1 Oct 2013 20:29:19 +0530
Message-ID: <CAKDJKT6kBi_axtn+qDBkwueRGn_zzOAdSstRF=x1OqX-TrO2XQ@mail.gmail.com>
Subject: Re: [PATCH] regulator: tps65090: remove usage of IS_ERR_OR_NULL
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-tegra@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thank you for your reply.

On Tue, Oct 1, 2013 at 2:52 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Oct 01, 2013 at 09:41:04AM +0530, Manish Badarkhe wrote:
>> This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
>> macro.
>
> Why?

Code use "IS_ERR_OR_NULL()" properly as per current implementation. But
as per patches [1], [2] below, the use of "IS_ERR_OR_NULL()" has been
deprecated.
Hence done this change.

[1] - http://www.mail-archive.com/linux-omap@vger.kernel.org/msg78030.html
[2] - http://comments.gmane.org/gmane.linux.power-management.general/33515

Please let me know your opinion about this change, If not necessary,
will revert back
this change.

Regards,
Manish Badarkhe
