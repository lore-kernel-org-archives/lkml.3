Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3JNLag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:30:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904Ab3JNLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:30:34 -0400
Message-ID: <525BD5D6.5050002@redhat.com>
Date: Mon, 14 Oct 2013 13:30:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, dzickus@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] generic kernel watchdog reset at pvclock read (v2)
References: <20131012003924.092908362@amt.cnet>
In-Reply-To: <20131012003924.092908362@amt.cnet>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/10/2013 02:39, Marcelo Tosatti ha scritto:
> v2:
> - do not create hung_task.h, move defines to sched.h (Don Zickus)
> - switch patch order (Paolo)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

