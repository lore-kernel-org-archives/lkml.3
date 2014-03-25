Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaCYRQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:16:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:60979 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaCYRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:16:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: behanw@converseincode.com
Subject: Re: [PATCH v4] LLVMLinux: Remove warning about returning an uninitialized variable
Date: Tue, 25 Mar 2014 18:16:10 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>
References: <1395506558.2143.18.camel@dabdike.int.hansenpartnership.com> <1395640404-27958-1-git-send-email-behanw@converseincode.com>
In-Reply-To: <1395640404-27958-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403251816.10589.arnd@arndb.de>
X-Provags-ID: V02:K0:aNcNfXUJlD1mMx1mm6TT2cYE3Bmk6ZqQcp9CTbVBuH8
 f8zv8twb2cIkoq6/g6zJhyhEx9u7WPS+QE5tvXxvHBJxgVIl88
 wYej5QXDF2RoAO+KEkafOCTuEJUVa/GK0oHCH74ewJV+d3zR0G
 PkEIzp1o/hdUXGxPjzoWACFNK0j6CoMg6+kya//q6NI0kj54vn
 kjTw4zUWo1hxfUU7cqxxepNVHUPYdzSAYMr3YzF2H+mO7QPT4A
 b9aWXjXoAl+6Y+Hovct3rqTtafxGJg9RCI9xifNvDakE7JuRJS
 13ypZGVXmpJA/9ULDxb5VBfkPumQxsaFHG0N7q7/70Tqtzs3AY
 Tu3yBdhv6WpdCmd0uw7rcZjrPRrliG+CbyMPlg5Zq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2014, behanw@converseincode.com wrote:
> 
> From: Behan Webster <behanw@converseincode.com>
> 
> Fix uninitialized return code in default case in cmpxchg-local.h
> 
> This patch fixes the code to prevent an uninitialized return value that is detected
> when compiling with clang. The bug produces numerous warnings when compiling the
> Linux kernel with clang.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
