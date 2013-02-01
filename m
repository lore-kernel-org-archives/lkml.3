Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3BAUUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:20:44 -0500
Received: from wolff.to ([65.117.131.163]:58935 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755858Ab3BAUUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:20:42 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 15:20:41 EST
Date: Fri, 1 Feb 2013 14:13:32 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: linux-kernel@vger.kernel.org
Subject: Problems with late 3.8-rc5 and 3.8-rc6 on i686
Message-ID: <20130201201332.GA2965@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been testing 3.8 kernels on Fedora. The last good kernel was 
3.8.0-0.rc5.git1.1.fc19.i686.PAE. I tested 3.8.0-0.rc5.git2.1.fc19.i686.PAE, 
3.8.0-0.rc5.git3.1.fc19.i686 and 3.8.0-0.rc6.git0.1.fc19.i686.PAE and found 
these all had two odd effects. 

One is that the rtkit-daemon service fails to start up and the other is that 
there are issues with X. One one machine with an rv280 based video card the 
background image doesn't show up in gdm and I can't enter a password in gdm. 
C-A-F2 does get me back to a vt. On another machine with a nv28 based video 
card I get the Oh no something went wrong page, but again I can still use 
C-A-F2 to get to a vt.

On an x86_64 machine I have tested through 3.8.0-0.rc5.git2.1.fc19.x86_64 and 
am not seeing either of these issues.
