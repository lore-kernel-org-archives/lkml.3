Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3A3Pmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:42:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38345 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab3A3Pmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:42:44 -0500
Message-ID: <51093F43.2090503@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2013 09:41:55 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: remove unused pool name
References: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013015-7182-0000-0000-000004CF0306
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 09:36 AM, Seth Jennings wrote:> zs_create_pool()
currently takes a name argument which is
> never used in any useful way.
>
> This patch removes it.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Crud, forgot the Acks...

Acked-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Rik van Riel <riel@redhat.com>

Thanks,
Seth

