Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbbAESr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:47:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbbAESr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:47:27 -0500
Message-ID: <54AADC38.2010508@oracle.com>
Date: Mon, 05 Jan 2015 13:47:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] virtio_pci: fix DEBUG_KOBJECT_RELEASE
References: <1420386340-7719-1-git-send-email-mst@redhat.com> <20150104162100.GA8153@redhat.com>
In-Reply-To: <20150104162100.GA8153@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2015 11:21 AM, Michael S. Tsirkin wrote:
> On Sun, Jan 04, 2015 at 06:02:13PM +0200, Michael S. Tsirkin wrote:
>> > This is based on Sasha's patch, with some tweaks.
>> > 
> 
> Sasha, I would appreciate it if you can send
> a Tested-by tag to confirm this + the del_vqs
> idempotent patches are sufficient to address
> all issues you have with 3.19.

I've tested the series, which fixed the issues I've reported:

	Tested-by: Sasha Levin <sasha.levin@oracle.com>


Thanks,
Sasha

