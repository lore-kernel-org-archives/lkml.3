Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab3DYBwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:52:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3DYBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:52:07 -0400
Message-ID: <51788C24.9020608@oracle.com>
Date: Thu, 25 Apr 2013 09:51:32 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: memcpy_fromio in dmi_scan.c
References: <1366636689.4503.35.camel@chaos.site>  <5175FF0F.9050206@oracle.com> <1366702122.4667.11.camel@chaos.site>  <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com> <1366831328.4618.476.camel@chaos.site>
In-Reply-To: <1366831328.4618.476.camel@chaos.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-04-25 03:22, Jean Delvare wrote:
> What is strange is that the call to memcpy_fromio was added a long 
> time ago, long before dmi_scan was enabled on ia64. 
I think memcpy_fromio is used to copy bios data to a mem buffer to speed 
up read access.

zduan

