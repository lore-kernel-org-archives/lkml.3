Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbaLHSPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:15:53 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:55203 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:15:51 -0500
Date: Mon, 8 Dec 2014 19:15:43 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v1] CPU hotplug: active_reader not woken up in some
 cases - deadlock
Message-ID: <20141208191543.45a1b18a@thinkpad-w530>
In-Reply-To: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120818-0013-0000-0000-000002231D38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The title should of course say active_writer  ... grml

David

