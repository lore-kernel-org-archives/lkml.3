Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3FDLsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3FDLsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:48:40 -0400
Date: Tue, 4 Jun 2013 17:18:12 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        Vasily Kulikov <segoon@openwall.com>
Subject: Re: [patch] cciss: info leak in cciss_ioctl32_passthru()
In-Reply-To: <20130604111640.GE23987@mwanda>
Message-ID: <alpine.LFD.2.03.1306041713400.12829@erqung.pbz>
References: <alpine.LFD.2.03.1306041602160.7145@erqung.pbz> <20130604111640.GE23987@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| No no.  Vasily patched cciss_ioctl32_big_passthru() and this patch
| changes cciss_ioctl32_passthru().

Oops, yeah, I missed the `big' part!

Thanks.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
