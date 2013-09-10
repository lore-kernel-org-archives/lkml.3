Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3IJBvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:51:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48648 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3IJBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:51:15 -0400
Message-ID: <522E7AF4.9060504@oracle.com>
Date: Tue, 10 Sep 2013 09:50:44 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries before
 add device
References: <522D685D.5060201@oracle.com> <20130909134131.GB24738@infradead.org>
In-Reply-To: <20130909134131.GB24738@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/13 21:41, Christoph Hellwig wrote:
>> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U)
> 
> Please reproduce without this weird crap loaded.
> 
These modules is filesystem and will not impact enclosure.

Thanks,
Joe




