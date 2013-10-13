Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3JMUOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 16:14:01 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54132 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3JMUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 16:13:59 -0400
Message-ID: <525AFF04.50306@gmail.com>
Date: Sun, 13 Oct 2013 14:13:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: autofs@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference in autofs4_expire_wait
References: <525736C7.9080400@gmail.com>	  <1381457199.2631.3.camel@perseus.fritz.box>	 <1381485327.2631.18.camel@perseus.fritz.box> <5257FD34.2060406@gmail.com> <1381542984.2272.21.camel@perseus.fritz.box>
In-Reply-To: <1381542984.2272.21.camel@perseus.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/13 7:56 PM, Ian Kent wrote:
> So more history please, had you used 3.11 for an extended amount of
> time, before using the 3.12-rc? IOW what's your kernel version use
> history please?

I think I did have a 3.11 installed, but was not doing a heavy 
nfs/autofs load. That started in the past week.

David
