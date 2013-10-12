Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3JLAnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:43:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab3JLAnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:43:49 -0400
In-Reply-To: <20131008010515.516032211@amt.cnet>
Message-Id: <20131012003924.092908362@amt.cnet>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 21:39:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: kvm@vger.kernel.org
Cc: dzickus@redhat.com, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [patch 0/2] generic kernel watchdog reset at pvclock read (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
- do not create hung_task.h, move defines to sched.h (Don Zickus)
- switch patch order (Paolo)

