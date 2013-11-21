Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3KUT5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:57:23 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38138 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KUT5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:57:19 -0500
Message-ID: <528E6599.6050302@wwwdotorg.org>
Date: Thu, 21 Nov 2013 12:57:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>
CC: Alex Courbot <acourbot@nvidia.com>, Tomasz Figa <t.figa@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com> <52828EF5.6090909@wwwdotorg.org> <CAOesGMhatp9ZQr=eTCtQ_9a_E9LXKdTCzJd+P7Sy9Ut9wtvnsA@mail.gmail.com> <5282E068.1070608@nvidia.com> <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com> <528E5596.7090606@wwwdotorg.org> <CAOesGMgB_FUDkD9=wgZgreaspEyKoSqpkpGZtzuUjb=G6m_nEg@mail.gmail.com> <20131121190051.GY16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131121190051.GY16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 12:00 PM, Russell King - ARM Linux wrote:
> On Thu, Nov 21, 2013 at 10:51:09AM -0800, Olof Johansson wrote:
>> An ack from Russell would be appreciated, or we'd need to set up a
>> shared branch given the Tegra dependencies that would go on top.
>> Either is ok with me.
> 
> Note that I'm *not* looking at anything new until after the merge window
> has closed, so I'm not acking or reviewing anything at the moment.

OK, that's fair. Do we need to ping you again or repost once -rc1 is
out, or do you have a TODO list that you'll check?
