Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaGOTBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:01:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaGOTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:01:44 -0400
Message-ID: <53C57B26.1020105@oracle.com>
Date: Tue, 15 Jul 2014 15:04:06 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC PATCH] x86_64,entry,xen: Do not invoke espfix64 on Xen
References: <08bf951548224b92c0316c93cf0064d90e392578.1405441297.git.luto@amacapital.net> <53C562B4.3030709@oracle.com> <CALCETrVU=y_ym9ZGwSDy1bwpx+qxga8V=kEi4g9Pubnv0A91nw@mail.gmail.com> <53C57A68.10100@oracle.com> <53C57A4E.1060000@zytor.com>
In-Reply-To: <53C57A4E.1060000@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 03:00 PM, H. Peter Anvin wrote:
> On 07/15/2014 12:00 PM, Boris Ostrovsky wrote:
>> One way or the other we need to disable espfix64 on PV --- I discovered
>> that one of Peter's tests crashes the hypervisor.
>>
> You do realize that that means you have bigger problems than just
> espfix, right?

Yes.

-boris
