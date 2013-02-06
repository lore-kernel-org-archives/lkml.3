Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3BFOEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:04:53 -0500
Received: from wolff.to ([65.117.131.163]:56793 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751807Ab3BFOEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:04:52 -0500
Date: Wed, 6 Feb 2013 08:04:15 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: JA =?iso-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
Message-ID: <20130206140415.GA5609@wolff.to>
References: <20130201201332.GA2965@wolff.to>
 <20130204232827.GA14752@wolff.to>
 <51104830.7060005@ono.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51104830.7060005@ono.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 00:45:52 +0100,
   JA Magallón <jamagallon@ono.com> wrote:
>
>I had also problems with this and other daemons...
>If you are using systemd, check if rtkit wants to run with PrivateTmp=yes.
>If this is so, then check that your /tmp is _not_ a symlink, but
>a real dir...

In this case it was using privatenetwork=yes when namespaces are enabled 
on 32 bit kernels. Possible an error status changed and systemd is behaving 
differently now due to that. We have a bug open in Fedora for this against 
rtkit, but I am going to recommend the submitter move it to systemd.

Thanks.
