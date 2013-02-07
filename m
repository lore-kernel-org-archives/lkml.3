Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3BGBxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:53:34 -0500
Received: from wolff.to ([65.117.131.163]:48783 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755409Ab3BGBxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:53:33 -0500
Date: Wed, 6 Feb 2013 19:52:59 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
Message-ID: <20130207015259.GA760@wolff.to>
References: <20130201201332.GA2965@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20130201201332.GA2965@wolff.to>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 14:13:32 -0600,
   Bruno Wolff III <bruno@wolff.to> wrote:
>I have been testing 3.8 kernels on Fedora. The last good kernel was 
>3.8.0-0.rc5.git1.1.fc19.i686.PAE. I tested 
>3.8.0-0.rc5.git2.1.fc19.i686.PAE, 3.8.0-0.rc5.git3.1.fc19.i686 and 
>3.8.0-0.rc6.git0.1.fc19.i686.PAE and found these all had two odd 
>effects.

This turned out to be due Fedora changing some config options to turn off 
namespaces for i686 when it was thought by some people that they had been 
off previously. (And so this wasn't thought to be a change.) This broke 
the private network feature of systemd, used by rtkit-daemon.

There is a new kernel build which fixes this.
