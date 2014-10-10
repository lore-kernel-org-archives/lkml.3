Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaJJAln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 20:41:43 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33522 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaJJAlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 20:41:42 -0400
Message-ID: <54372B43.2010801@inktank.com>
Date: Thu, 09 Oct 2014 17:41:39 -0700
From: Dan Mick <dan.mick@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ceph: fix bool assignments
References: <1412889395-19350-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1412889395-19350-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/09/2014 02:16 PM, Fabian Frederick wrote:
> Fix some coccinelle warnings:
> fs/ceph/caps.c:2400:6-10: WARNING: Assignment of bool to 0/1


> -	bool wake = 0;
> +	bool wake = false;

FWIW, that message is backwards: it should say "WARNING: Assignment of
0/1 to bool" (I know, it's a coccinelle issue, but..)


