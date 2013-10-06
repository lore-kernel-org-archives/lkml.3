Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3JFS0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 14:26:33 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53850 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3JFS0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 14:26:31 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5251AB52.3000506@roeck-us.net>
Date: Sun, 06 Oct 2013 11:26:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rob Herring <rob.herring@calxeda.com>
CC: James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-metag@vger.kernel.org
Subject: Commit f26150004 (metag: use common of_flat_dt_match_machine) causes
 metag build failures in linux-next
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/metag/kernel/devtree.c: In function 'setup_machine_fdt':
arch/metag/kernel/devtree.c:52: error: 'arch_get_next_mach' undeclared (first use in this function)
arch/metag/kernel/devtree.c:52: error: (Each undeclared identifier is reported only once
arch/metag/kernel/devtree.c:52: error: for each function it appears in.)
arch/metag/kernel/devtree.c:52: warning: assignment discards qualifiers from pointer target type
make[1]: *** [arch/metag/kernel/devtree.o] Error 1

Not surprising, since arch_get_next_mach() is not defined for metag.

Guenter
