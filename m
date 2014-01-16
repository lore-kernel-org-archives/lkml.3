Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaAPJqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:46:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaAPJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:46:41 -0500
Message-ID: <52D7AA3F.2030501@redhat.com>
Date: Thu, 16 Jan 2014 10:45:35 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/4] zram: report failed read and writes stats
References: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com> <1389780977-18949-5-git-send-email-sergey.senozhatsky@gmail.com> <20140116005844.GN1992@bbox>
In-Reply-To: <20140116005844.GN1992@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 01:58 AM, Minchan Kim wrote:
> On Wed, Jan 15, 2014 at 01:16:17PM +0300, Sergey Senozhatsky wrote:
>> zram accounted but did not report numbers of failed read
>> and write queries. make these stats available as failed_reads
>> and failed_writes attrs.
>>
>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> 

This of course depends on third patch, but since I have no objection
to the ZRAM_ATTR_RO() macro part:

Acked-by: Jerome Marchand <jmarchan@redhat.com>

