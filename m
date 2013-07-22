Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab3GVPzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:55:01 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:35846 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3GVPy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:54:59 -0400
Date: Mon, 22 Jul 2013 12:54:52 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix build with perl 5.18
Message-ID: <20130722155452.GF2157@ghostprotocols.net>
References: <1372063394-20126-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372063394-20126-1-git-send-email-kirill@shutemov.name>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 24, 2013 at 11:43:14AM +0300, Kirill A. Shutemov escreveu:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> perl.h from new Perl release doesn't like -Wundef and -Wswitch-default:
> 

Thanks, applied after minor fixup, sorry for the delay.

- Arnaldo
