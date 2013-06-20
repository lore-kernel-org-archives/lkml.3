Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161203Ab3FTU1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:27:38 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:26188 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161142Ab3FTU1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:27:37 -0400
X-AuditID: cbfec37d-b7f036d000004805-b3-51c365b88498
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: Christian Stroetmann <stroetmann@ontolinux.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tux3 <tux3@tux3.org>
Subject: Re: Tux3 Report: Meet Shardmap, the designated successor of HTree
Thread-topic: Tux3 Report: Meet Shardmap, the designated successor of HTree
Thread-index: Ac5t1+vVOrBF/IDKR66mJLNzgb4UiA==
Date: Thu, 20 Jun 2013 20:27:34 +0000
Message-id: <1EC23D2B9975384993D85B5DB93AAE8860E5EB@sisaex02sj>
References: <1EC23D2B9975384993D85B5DB93AAE8860E5A2@sisaex02sj>
 <51C353C6.2070406@ontolinux.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9hP90dqYcDDVYfEbLYs/cki8XlXXPY
	LLpfVVp8OPCZ0YHFY+P6TjaPb09fsXl83iQXwBzFZZOSmpNZllqkb5fAlbHu2ifGgr9sFXsv
	72NpYDzH2sXIySEhYCKx5ulXdghbTOLCvfVsXYxcHEICyxglXpx7xQLh9DJJNOx8DOXMZ5Q4
	vXcLI0gLm4CZxNLjZ5hAbBEBY4nZM7aygNjMAuUSDW3XwWxhAS+JR6eWskHUeEscBVvBAWTr
	Sby4kwISZhFQlZg/6SDYGF4Be4n1cy6BXSQkkCRxZOFcsDgj0HXfT61hghgvLtHcepMF4moB
	iSV7zjND2KISLx//YwUZLyGgKLF9tRVEuZbE+p3HoVq1JZ68u8AKsUpQ4sfkeywTGMVmIZk6
	C0nLLCQts5C0LGBkWcUoVlqcXFCclJ5aYaJXnJhbXJqXrpecn7uJERJbtTsY73+1OcQowMGo
	xMMboHQ4UIg1say4MvcQowQHs5II76NgoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG9Dn83XdS
	tWzXqTP8ZTLclJtUOfGBzjqeU5x+25nXKVwU/JpyUFNifpDxbL7sx0unTt6TwFYgPaX2tv7O
	XZ4st1/qt838H5291pjvyOOTmV5zv53cfey44KXnzEt+8Oy/XTjluKgES/6DLKldJs6MkX+m
	m+ke45dRtf/zzY8v1Opy04Idfh/FlViKMxINtZiLihMBT+B3CIsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 12:12 PM, Christian Stroetmann wrote:
> 1. Stop copying my intellectual properties related with file systems and
> implementing them. You always came several months too late and I am not
> interested to let it become a running gag, definitely.
> 2. Stop marketing my ideas, especially in a way that confuses the public
> about the true origin even further. I am already marketing them on my own.
> 3. Give credits to my intellectual properties in any case, even if you
> make a derivation, and take care about the correct licensing.

Could you please direct us to details of your design so that we may 
properly appreciate it?

Note that the key idea in Shardmap is not simply logging a hash table, 
but sharding it and logging it as a forest of fifos.

Regards,

Daniel

