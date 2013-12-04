Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3LDIZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:25:16 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:33246 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3LDIZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:25:14 -0500
MIME-Version: 1.0
In-Reply-To: <1386143213.75864.YahooMailNeo@web163902.mail.gq1.yahoo.com>
References: <1386143213.75864.YahooMailNeo@web163902.mail.gq1.yahoo.com>
Date: Wed, 4 Dec 2013 09:25:13 +0100
Message-ID: <CAFLxGvy55j+6T0jsKwThUdVxSkDWdBErVWE-MW+4ZKwPO-eHrA@mail.gmail.com>
Subject: Re: How to change erasesize of a partition
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Suki Buryani <sukiburyani@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dev@uclinux.org" <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 8:46 AM, Suki Buryani <sukiburyani@yahoo.com> wrote:
> hi,
>
> i have few changes in my mtd partitions, i want to change the erasesize of a partition. can any one tell me where i should look to change erasesize of mtd3...

The erase size is defined by the MTD device, you cannot change it.

-- 
Thanks,
//richard
