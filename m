Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaAXTlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:41:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaAXTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:41:35 -0500
Date: Fri, 24 Jan 2014 20:39:50 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
Message-ID: <20140124193950.GA21365@hpx.cz>
References: <20140123190648.720195687@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

could 3.12.9 and 3.10.28 include
  0dce7cd kvm: x86: fix apic_base enable check
?  It fixes a regression applied to 3.10.26 and 3.12.7.

Stable was mentioned on kvm-list[1], but it might have been forgotten.
More information is in bugzilla[2].

Thanks.


---
1: http://www.spinics.net/lists/kvm/msg99343.html
2: https://bugzilla.redhat.com/show_bug.cgi?id=1055872
