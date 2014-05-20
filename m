Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaETHmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:42:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaETHmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:42:01 -0400
Date: Tue, 20 May 2014 08:41:20 +0100
From: Joe Thornber <thornber@redhat.com>
To: naota@elisp.net
Cc: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: check era->md is non-NULL before closing it
Message-ID: <20140520074120.GA30857@debian>
Mail-Followup-To: naota@elisp.net, Joe Thornber <ejt@redhat.com>,
	dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
References: <87d2f9ds17.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2f9ds17.fsf@elisp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:53:56PM +0900, naota@elisp.net wrote:
> In era_ctr(), era->md remain NULL until it's set after metadata_open().
> On the other hand, era_destroy() assume era->md is non-NULL and it is
> called by era_ctr() before initializing the value.

Thanks.  This change went into my tree on the 11th March, I'll chase
and see why it's not upstream yet.

- Joe
