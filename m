Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3EPU5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:57:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3EPU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:57:03 -0400
Message-ID: <51954802.1040309@oracle.com>
Date: Thu, 16 May 2013 16:56:34 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@redhat.com, aquini@redhat.com, mst@redhat.com,
        amit.shah@redhat.com, anton@enomsg.org
Subject: Re: [RFC v2 0/2] virtio_balloon: auto-ballooning support
References: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1368111229-29847-1-git-send-email-lcapitulino@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 10:53 AM, Luiz Capitulino wrote:
> Hi,
> 
> This series is a respin of automatic ballooning support I started
> working on last year. Patch 2/2 contains all relevant technical
> details and performance measurements results.
> 
> This is in RFC state because it's a work in progress.

Hi Luiz,

Is there a virtio spec patch I could use to get it implemented on
kvmtool?


Thanks,
Sasha
