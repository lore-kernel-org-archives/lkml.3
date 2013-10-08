Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3JHHCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:02:13 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:58096 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHHCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:02:11 -0400
Date: Tue, 8 Oct 2013 09:02:09 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH v2 07/14] mips: select ARCH_MAY_HAVE_PC_PARPORT
Message-ID: <20131008070209.GF1615@linux-mips.org>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
 <1381209030-351-8-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381209030-351-8-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 01:10:23AM -0400, Mark Salter wrote:

> Architectures which support CONFIG_PARPORT_PC should select
> ARCH_MAY_HAVE_PC_PARPORT.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
