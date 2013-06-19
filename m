Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913Ab3FSQmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934793Ab3FSQmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:42:39 -0400
Message-ID: <51C1DF77.5030006@redhat.com>
Date: Wed, 19 Jun 2013 17:42:31 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jan Kratochvil <jan.kratochvil@redhat.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>, Oleg Nesterov <oleg@redhat.com>,
        Pedro Alves <palves@redhat.com>
Subject: Re: [PATCH] ptrace: make PTRACE_DETACH work on non-stopped tracees.
References: <1371654936-31742-1-git-send-email-dvlasenk@redhat.com> <20130619160930.GA15631@host2.jankratochvil.net>
In-Reply-To: <20130619160930.GA15631@host2.jankratochvil.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 05:09 PM, Jan Kratochvil wrote:
> On Wed, 19 Jun 2013 17:15:36 +0200, Denys Vlasenko wrote:
>> CCing Jan to hear his comments from gdb side.

PTRACE_DETACH takes a signal number in the data parameter.
What happens to if the tracer passes a non-zero signal?

-- 
Pedro Alves

