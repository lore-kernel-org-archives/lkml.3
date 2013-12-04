Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3LDCCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:02:20 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55600 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3LDCCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:02:17 -0500
MIME-Version: 1.0
In-Reply-To: <529CFDE4.9070409@canonical.com>
References: <52965493.8060208@canonical.com>
	<CAE9FiQV104AgXC+EaSvBzuRg7WTLEDvQZETPeWHY4gdpg2eY_w@mail.gmail.com>
	<529CFDE4.9070409@canonical.com>
Date: Tue, 3 Dec 2013 18:02:17 -0800
X-Google-Sender-Auth: 6oVFap8tyG16Oyjt6LYaeV4xgXs
Message-ID: <CAE9FiQW1V-D1p1ZhLskRESgYA0YpmiSo+os7AgMeCKNrCVbeTQ@mail.gmail.com>
Subject: Re: [REGRESSION][v3.4-rc1] PCI: add a PCI resource reallocation
 config option
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 1:38 PM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> Your patches were tested against the 3.5 tree.  The patches did fix the
> bug, and allowed the Intel x520 NIC's to work properly.  We were unable
> to test this with Linus' tree due to another bug, which prevents the
> system from booting.  We are looking deeper into that bug and should be
> able to test the mainline tree at some point.
>
> Testing against the 3.5 tree required that I cherry-pick the following
> commits: ff35147, 55ed83a, 967260c and 223d96f.  However, that shouldn't
> affect the test results of your patches.

Thanks.

Will repost them separately with stable tag.

Yinghai
