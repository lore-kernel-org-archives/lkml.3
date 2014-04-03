Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaDCSCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:02:30 -0400
Received: from omr-d03.mx.aol.com ([205.188.109.200]:34643 "EHLO
	omr-d03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaDCSCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:02:21 -0400
References: <533D8D73.1090603@pobox.com> <20140403171643.GB28790@pad.redhat.com> <533D9F8A.6030001@pobox.com>
To: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Subject: /proc/slab_allocators question
In-Reply-To: <533D9F8A.6030001@pobox.com>
X-MB-Message-Source: WebUI
MIME-Version: 1.0
From: Pietro Paolini <pulsarpietro@aol.com>
X-MB-Message-Type: User
Content-Type: text/plain; charset="us-ascii"; format=flowed
X-Mailer: AOL Webmail 38466-STANDARD
Message-Id: <8D11D7DFDC0DCD5-1BF8-2054F@webmail-va038.sysops.aol.com>
X-Originating-IP: [92.109.158.175]
Date: Thu, 3 Apr 2014 14:02:20 -0400 (EDT)
x-aol-global-disposition: G
x-aol-sid: 3039ac1d1bd0533da22c3349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello everyone,

I am experiencing a problem where the system reboot due low memory 
conditions and looking at the
/proc/slabinfo

I am able to see that a lot of memory is being used by the size-1024 
cache name which reports a high number of active objects, then
in order to debug this situation I tried to compile with :

CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

Now I am able to cat the /proc/slab_allocators leaf but that name, nor 
either all the size-* - are present
in that output, I guess because that memory is used by the kmalloc() 
functions.

Than how can I trace who allocates  all that memory in my system ?

Best Regards,
Pietro
