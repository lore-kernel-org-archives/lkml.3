Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3JPP2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:28:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60777 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3JPP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:28:14 -0400
Date: Wed, 16 Oct 2013 08:27:42 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: David Laight <David.Laight@aculab.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Message-ID: <20131016152742.GB25073@us.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101615-9332-0000-0000-000001CAEA9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Laight [David.Laight@aculab.com] wrote:
| 
| I can't help feeling the code could do with some comments about
| which actual instructions are selected where.

At a high level, only the load and store instructions are selected.

I added a reference to the Appendix F (Opcode maps) in the function
header.  The opcode maps is a table of upper x lower values. From
that table it should be fairly straightforward which instructions
are selected.

How about I add this to the function header ?

 * Please use the table in Appendix F (opcode maps) to determine
 * events selected by this function.

There are over 100 instructions selected by this list and wasn't
sure if we should list them all.

Sukadev

