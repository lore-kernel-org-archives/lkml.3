Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3GOS5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:57:13 -0400
Received: from longford.logfs.org ([213.229.74.203]:59804 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3GOS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:57:11 -0400
Date: Mon, 15 Jul 2013 13:25:46 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] [SCSI] sg: fix race condition when do exclusive
 open
Message-ID: <20130715172545.GA20517@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
 <20130605154106.GA2737@logfs.org>
 <51BF0ADD.1080604@oracle.com>
 <20130705173953.GA15089@logfs.org>
 <51D852DC.4070808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51D852DC.4070808@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 July 2013 01:24:44 +0800, vaughan wrote:
> 
> Do you agree that I use a per device spin_lock 'sfd_lock' to protect
> sfds list and leave sg_index_lock
> only protect the global sg device lookup? I think it's reasonable
> for concurrency.

That bit looks fine to me.  I don't think it matters much, but sure,
why not!

Jörn

--
One of the painful things about our time is that those who feel certainty
are stupid, and those with any imagination and understanding are filled
with doubt and indecision.
-- Bertrand Russell
