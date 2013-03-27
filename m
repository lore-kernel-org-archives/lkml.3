Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3C0NFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:05:31 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:50867 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3C0NFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <CA+ekxPUJwgEAkXg4y0qgMAWe2O-oxasHTKMCcCGP=PW4MdtU9Q@mail.gmail.com>
References: <CA+ekxPUJwgEAkXg4y0qgMAWe2O-oxasHTKMCcCGP=PW4MdtU9Q@mail.gmail.com>
Date: Wed, 27 Mar 2013 07:05:29 -0600
Message-ID: <CA+ekxPVwhi3fL-UZX=TCebZ3RufG00w6-+o=wuHh8h9mcRYrVw@mail.gmail.com>
Subject: Re: Attempted Breakin of Go Daddy by LKML Member (Foiled)
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These scumbags are so predictable.  After the LKML mailing went
planetwide, this idiot and his buddies came right back in from another
duckblind and accessed the site -- sorry guys, I punched right through
your duckblind.  Here is this dirtbags actual IP address.  I've seen
this address to -- another Merkey mission poster.

2013-03-27 04:53:07	GET /	5.14.29.243	5-14-29-243.residential.rdsnet.ro	
2013-03-27 04:53:43	GET
/?page=maillist	5.14.29.243	5-14-29-243.residential.rdsnet.ro
2013-03-27 04:53:53	GET /	5.14.29.243	5-14-29-243.residential.rdsnet.ro	

Wonder who on LKML uses this address.  Dude, you are nailed.

Jeff

On 3/27/13, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> After posting the latest MDB version, this linux developer (which I
> monitor from San Diego periodically) attempted a break in of godaddy's
> servers with an XSS embedded script attack.  This notice is posted to
> warn others of this address.  I am certain Linus and Co. can check
> kernel.org and track down this address if they are a user of LKML.
> The following is provided from server logs at godaddy.
>
> 2013-03-26 16:36:16	GET
> /?page=maillist&name=press	108.64.212.227	108-64-212-227.lightspeed.sndgca.sbcglobal.net
> 2013-03-26 16:36:21	GET
> /?page=account&action=messages	108.64.212.227	108-64-212-227.lightspeed.sndgca.sbcglobal.net
> 2013-03-26 16:36:29	GET
> /?page=maillist&name=discussion	108.64.212.227	108-64-212-227.lightspeed.sndgca.sbcglobal.net
> 2013-03-26 16:36:48	GET
> /?page=maillist&name=%3Cscript%3Ealert('woot');%3C/script%3E	108.64.212.227	108-64-212-227.lightspeed.sndgca.sbcglobal.net
> 2013-03-26 16:37:01	GET /?page=admin	108.64.212.227	
>
> geolocation shows the address is a duckblind from.  He is a linux user
> on Ubuntu.  See:
> User-Agent : Mozilla/5.0 (X11; U; Linux i686; it-IT; rv:1.9.0.2)
> Gecko/2008092313 Ubuntu/9.25 (jaunty) ...
>
> http://geo-location.com/host-76-219-253-168.lightspeed.sndgca.sbcglobal.net/
>
> Here is a description of this type of attack.
>
> http://www.acunetix.com/websitesecurity/cross-site-scripting/
>
> This IP address has been reported to godaddy IAW their site policies
> on breakin attempts to their hosted servers.  So I know you are
> trolling this list hacker (LKML) and I want to let you know your IP
> address in San Diego won't be around much longer.  Have a nice day.
>
> Jeff Merkey
>
