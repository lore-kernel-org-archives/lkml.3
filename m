Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKYQqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaKYQqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:46:34 -0500
Message-Id: <20141125164517.205894226@redhat.com>
User-Agent: quilt/0.60-1
Date: Tue, 25 Nov 2014 14:45:17 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Luiz Capitulino <lcapitulino@redhat.com>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [patch -rt 0/2] use simple waitqueue for kvm vcpu waitqueue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which allows waking up vcpu from hardirq context.


