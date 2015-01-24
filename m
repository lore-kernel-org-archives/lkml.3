Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbbAXBco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:32:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30748 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbAXBck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:32:40 -0500
Message-ID: <54C2F625.5010204@oracle.com>
Date: Fri, 23 Jan 2015 20:32:21 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: minyard@acm.org, nick <xerofoify@gmail.com>
CC: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] char:ipmi: Free ipmi_recv_msg messages from the linked
 list,recv_msgs for the function,ipmi_release in the file,ipmi_devintf.c
References: <1422036143-27808-1-git-send-email-xerofoify@gmail.com> <54C292A7.9090000@gmail.com> <54C29A51.1050904@acm.org>
In-Reply-To: <54C29A51.1050904@acm.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 02:00 PM, Corey Minyard wrote:
> On 01/23/2015 12:27 PM, nick wrote:
>> > Corney,
>> > Hope this patch fixes the issue. Sorry about missing that kfree
>> > being required. :(
> Well, the kfree needs to be after the free of the messages.    You can't
> use an item after you free it.

As you can see, his patches aren't event tested. See https://lkml.org/lkml/2014/8/4/206 .

Thanks,
Sasha
