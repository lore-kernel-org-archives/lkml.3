Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaDXQqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:46:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338AbaDXQqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:46:37 -0400
Message-ID: <53593FE3.5000606@oracle.com>
Date: Thu, 24 Apr 2014 12:46:27 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm: hangs in collapse_huge_page
References: <534DE5C0.2000408@oracle.com>
In-Reply-To: <534DE5C0.2000408@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:06 PM, Sasha Levin wrote:
> Hi all,
> 
> I often see hung task triggering in khugepaged within collapse_huge_page().
> 
> I've initially assumed the case may be that the guests are too loaded and
> the warning occurs because of load, but after increasing the timeout to
> 1200 sec I still see the warning.

Ping? It happens quite often right now.


Thanks,
Sasha
