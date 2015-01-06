Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbbAFQ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:28:50 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:36173 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbAFQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:28:48 -0500
Message-ID: <54AC0D3C.7000203@6wind.com>
Date: Tue, 06 Jan 2015 17:28:44 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexander Kuleshov <kuleshovmail@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: proc: use the PDE to to get proc_dir_entry
References: <1419688366-26796-1-git-send-email-kuleshovmail@gmail.com>
In-Reply-To: <1419688366-26796-1-git-send-email-kuleshovmail@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/12/2014 14:52, Alexander Kuleshov a écrit :
> Use the PDE to get proc_dir_entry instead of coding it directly.
>
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
