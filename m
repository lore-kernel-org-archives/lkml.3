Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaCBWYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:24:35 -0500
Received: from imta-35.everyone.net ([216.200.145.35]:34598 "EHLO
	imta-35.everyone.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaCBWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:24:34 -0500
X-Eon-Dm: dm23
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20140302142352.52A6A3E3@m0005309.ppops.net>
Date: Sun, 2 Mar 2014 14:23:52 -0800
From: "NoTo CTTE" <usspookslovesystmd@muchomail.com>
Reply-To: <usspookslovesystmd@muchomail.com>
To: <yaro@marupa.net>
Cc: <scott.ferguson.debian.user@gmail.com>, <debian-devel@lists.debian.org>,
        <debian-ctte@lists.debian.org>, <debian-vote@lists.debian.org>,
        <debian-project@lists.debian.org>, <linux-kernel@vger.kernel.org>,
        <pascal@plouf.fr.eu.org>, <yaro@marupa.net>,
        <cbannister@slingshot.co.nz>, <andreimpopescu@gmail.com>,
        <ghaverla@materialisations.com>, <debian-mirrors@lists.debian.org>,
        <debian-security@lists.debian.org>, <debian-user@lists.debian.org>,
        <debian-ctte@lists.debian.org>
Subject: Re: Four people decided the fate of debian with systemd. Bad faith likely -
 SysV is fine
X-Eon-Sig: AQO+z1hTE694VuyuPAEAAAAQ,a9738097c8e1bbcade4836a37c2c48bf
X-Originating-Ip: 5.135.180.223
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-02_02:2014-02-28,2014-03-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1403020150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You say nothing because there is nothing that you can say.

Simplicity is beautiful, and it works.

Systemd is a nightmare, but you are using politics and psyops to push it on
every single linux user, every distro, everywhere.

I showed you code that does your vaunted concurrent boot systemddeeeee in a few
lines of shell.

That simplicity was the way unix and linux was, before the windows programmers
and the govt funded companies sunk their teeth into linux.

You know what & does.
I guess not, you're too new to gnu.

--- yaro@marupa.net wrote:

From: yaro@marupa.net
To: usspookslovesystmd@muchomail.com
Subject: Re: Four people decided the fate of debian with systemd. Bad faith likely - SysV is fine
Date: Sun, 02 Mar 2014 16:15:41 -0600

On Sunday, March 02, 2014 02:12:48 PM NoTo CTTE wrote:
> System V is NOT hard to "maintain"
> The scripts were written YEARS ago. They're fine. They do NOT need to be
> changed. Debian SysV has concurrent boot aswell.
> 
> Systemd is a poison apple. 200k lines of unaudited root privlege code. A
> consulting service to go along with this new _operating system_
> 
> Here's an under 100 line init with concurrent boot:
> 
> #include <signal.h>
> #include <unistd.h>
> 
> int main()
> {
> sigset_t set;
> int status;
> 
> if (getpid() != 1) return 1;
> 
> sigfillset(&set);
> sigprocmask(SIG_BLOCK, &set, 0);
> 
> if (fork()) for (;;) wait(&status);
> 
> sigprocmask(SIG_UNBLOCK, &set, 0);
> 
> setsid();
> setpgid(0, 0);
> return execve("/etc/rc", (char *[]){ "rc", 0 }, (char *[]){ 0 });
> }
> 
> >/etc/rc is a shell script
> >syslogd && getty ; udev ; network-config ; sshd & cron & nginx
> 
> see how much bullsht systemd is.
> 
> 
> _____________________________________________________________
> The Free Email with so much more!
> =====> http://www.MuchoMail.com <=====

It'd be almost too easy to mock a laughable post like this, but I'll let 
someone else do it. It's just not fun anymore.

Conrad




_____________________________________________________________
The Free Email with so much more!
=====> http://www.MuchoMail.com <=====
