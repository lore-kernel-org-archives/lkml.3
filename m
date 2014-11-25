Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKYQr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:47:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaKYQrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:47:22 -0500
Message-ID: <5474B1DC.1060805@redhat.com>
Date: Tue, 25 Nov 2014 11:44:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch -rt 0/2] use simple waitqueue for kvm vcpu waitqueue
References: <20141125164517.205894226@redhat.com>
In-Reply-To: <20141125164517.205894226@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 11:45 AM, Marcelo Tosatti wrote:
> Which allows waking up vcpu from hardirq context.
> 
> 
Changelog?

Why?
