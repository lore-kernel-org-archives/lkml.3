Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaGOTAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:00:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57772 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734AbaGOTAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:00:40 -0400
Message-ID: <53C57A4E.1060000@zytor.com>
Date: Tue, 15 Jul 2014 12:00:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [RFC PATCH] x86_64,entry,xen: Do not invoke espfix64 on Xen
References: <08bf951548224b92c0316c93cf0064d90e392578.1405441297.git.luto@amacapital.net> <53C562B4.3030709@oracle.com> <CALCETrVU=y_ym9ZGwSDy1bwpx+qxga8V=kEi4g9Pubnv0A91nw@mail.gmail.com> <53C57A68.10100@oracle.com>
In-Reply-To: <53C57A68.10100@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 12:00 PM, Boris Ostrovsky wrote:
> 
> One way or the other we need to disable espfix64 on PV --- I discovered
> that one of Peter's tests crashes the hypervisor.
> 

You do realize that that means you have bigger problems than just
espfix, right?

	-hpa


