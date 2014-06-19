Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaFSPgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:36:06 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57204 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128AbaFSPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:35:59 -0400
Date: Thu, 19 Jun 2014 17:35:55 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: How to disable Lazy Preempt in the kernel
Message-ID: <20140619153555.GA1740@fancy-poultry.org>
References: <1403190681610-885003.post@n7.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403190681610-885003.post@n7.nabble.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V02:K0:5VGgLev0RFHTEazYRNkPs5RHiJ6CZrE3+wnFUOgBLy/
 Arx7+WD4Ma8j7iUYkA7F05T0D5EH0Dzrv0BCiWggjDKWpX/mCS
 0vv5vwIMy5DUQBVpYItFqqkYUc7bOgM/uDlYam5ZiOTLTqRouj
 ymPWxpz+VWWrv6pwIzXT4AImXSal1niYwkee2apien+LF4RXJ3
 U+LcOpGQwHkwQeQLhIf5UDawv8I9AWAxtcTK7V2StkOXFNVzHA
 sHBdOR7ciRSnU0XfImyz6BwGbiazYwg8V2HL7Y3CCvjgJFAtzm
 igAfre9KKbVl5C9xhSR3aw16nE6Hh6VcbjAXFDc82XLyGyhR8y
 Hq+vk9rzH7wIQC2XU+LVmay4fgpMhHrv0CmdxHVjQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.06.2014, tdjames wrote: 

> How do I disable lazy preempt?

echo NO_PREEMPT_LAZY >/sys/kernel/debug/sched_features

