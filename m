Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3BDX3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:29:39 -0500
Received: from wolff.to ([65.117.131.163]:32966 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754629Ab3BDX31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:29:27 -0500
Date: Mon, 4 Feb 2013 17:28:27 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
Message-ID: <20130204232827.GA14752@wolff.to>
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
>
>One is that the rtkit-daemon service fails to start up and the other 
>is that there are issues with X. One one machine with an rv280 based 
>video card the background image doesn't show up in gdm and I can't 
>enter a password in gdm. C-A-F2 does get me back to a vt. On another 
>machine with a nv28 based video card I get the Oh no something went 
>wrong page, but again I can still use C-A-F2 to get to a vt.

I am still seeing this with 3.8.0-0.rc6.git1.1.fc19.i686.PAE.

However, I have found the GUI issues are because gnome is waiting on the 
rtkit-daemon and once it times out, things are OK. So the issue is just 
that the recent kernels break something for the rtkit-daemon service 
on i686.
