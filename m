Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaEBHL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 03:11:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:37279 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaEBHL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 03:11:27 -0400
Message-ID: <5363451B.8080300@linutronix.de>
Date: Fri, 02 May 2014 09:11:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RT 1/3] rt: Move migrate_disable up in trylocks
References: <20140501004757.583708392@goodmis.org> <20140501005004.241785945@goodmis.org>
In-Reply-To: <20140501005004.241785945@goodmis.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 02:47 AM, Steven Rostedt wrote:

Could this wait until it appears in the development release?

Sebastian
