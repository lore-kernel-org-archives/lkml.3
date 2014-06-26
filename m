Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbaFZAaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:30:35 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43351 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaFZAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:30:34 -0400
Date: Wed, 25 Jun 2014 17:30:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wu Yu-Chen <lennox.wu@gmail.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, David Rientjes <rientjes@google.com>,
        Liqin Chen <liqin.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix
 'SCORE_' for related macros
Message-ID: <20140626003019.GA28457@roeck-us.net>
References: <BAY404-EAS3244E3E66FF1100E4753CC9B0180@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BAY404-EAS3244E3E66FF1100E4753CC9B0180@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 12:05:33AM +0000, Wu Yu-Chen wrote:
> As I said, these macros are useless currently. I don’t think users will use these macros since the kernel doesn’t respond these macros. However, you are welcome to provide your idea 😊
> 
Just drop them entirely.

Guenter
