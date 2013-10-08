Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3JHM5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab3JHM5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:57:10 -0400
Message-ID: <1381237001.17503.72.camel@deneb.redhat.com>
Subject: Re: [PATCH] arm64: add asm-generic parport.h
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Date: Tue, 08 Oct 2013 08:56:41 -0400
In-Reply-To: <1381182265-11271-1-git-send-email-robherring2@gmail.com>
References: <1381182265-11271-1-git-send-email-robherring2@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 16:44 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Add asm-generic/parport.h to help fix allyesconfig builds.
> 

See:

http://www.spinics.net/lists/arm-kernel/msg267957.html
http://www.spinics.net/lists/linux-arch/msg23167.html

and finally,

https://lkml.org/lkml/2013/10/8/12


