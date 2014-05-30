Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaE3HEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:04:40 -0400
Received: from zougloub.eu ([198.27.83.45]:52073 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbaE3HEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:04:38 -0400
Date: Fri, 30 May 2014 03:06:18 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bad DMA from Marvell 9230
Message-ID: <20140530030618.5ad4f447@Vantage>
In-Reply-To: <1395903457.5569.89.camel@pasglop>
References: <1395903457.5569.89.camel@pasglop>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2014 17:57:37 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> I've been trying a 9230 on a power box here (a 9235 on the same
> machine works fine) and it blows up with an IOMMU violation early
> during init.

Hi,

That's https://bugzilla.kernel.org/show_bug.cgi?id=42679
if you haven't already found it.

-- 
Jérôme
