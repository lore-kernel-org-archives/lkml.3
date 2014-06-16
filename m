Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaFPRSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:18:50 -0400
Received: from linode.aoot.com ([69.164.194.13]:54642 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaFPRSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:18:49 -0400
Message-ID: <539F26F5.8030702@opengridcomputing.com>
Date: Mon, 16 Jun 2014 12:18:45 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>
CC: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>	<539F0DAF.1020802@opengridcomputing.com>	<CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com> <CAPDOMVh4iBhWe50LZtiotpgWBn3fhX1jofyeAeYW4kHxx+Q4FQ@mail.gmail.com>
In-Reply-To: <CAPDOMVh4iBhWe50LZtiotpgWBn3fhX1jofyeAeYW4kHxx+Q4FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/2014 10:45 AM, Nick Krause wrote:
> Can we close this bug or is it still a issue as we can'
> return NULL from kfree or kfree_skb. Here is the bug
> ID 44631 I would close it if we are done with the bug
> otherwise I think there are no other issues with
> allocating a skb,
>

In what database is this bug ID 44631?
