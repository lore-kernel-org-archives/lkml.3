Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907Ab3I0CVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:21:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62624 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3I0CVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:21:35 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-2b-5244ebad50c6
Date: Fri, 27 Sep 2013 02:21:33 +0000 (GMT)
From: Jongman Heo <jongman.heo@samsung.com>
Subject: Re: Re: Re: Re: Regression caused by commit 4bdc33ed
 ("NFSDv4.2: Add NFS v4.2 support to the NFS server")
To: "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: jongman.heo@samsung.com
MIME-version: 1.0
X-MTR: 20130927020931663@jongman.heo
Msgkey: 20130927020931663@jongman.heo
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130927020931663@jongman.heo
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <15262316.12141380248492298.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42JZI2JSrLv2tUuQwbf5GhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj3Z2JrAV/dCtuXZvD0sD4QKeLkZNDSEBN4ubnQ4wgtoSAicSR
	V9vZIWwxiQv31rN1MXIB1SxllDj+/AQrTNHvic9ZIBLzGSXm/eoE62YRUJVoOviXDcRmE9CR
	6Pi/H6iBg0NYoEji42YWkLCIwApGiXs/EyAWK0pcW7oYrJxXQFDi5MwnLBDzVSQOz57AChFX
	lXjX+hUqLi5xYe4lqON4JWa0P4WKy0lM+7qGGcKWljg/awMjzAOLvz+GivNLHLu9gwnkHJDe
	J/eDYcbs3vyFDcIWkJh65iBUq6bEjSOLmSBsPok1C9+ywIzZdWo5M0zv/S1zwWqYgV6Z0v2Q
	HWQ8M1Dv+l36qL7iALIdJbbedwEFmoRAL4fEyaXrWScwKs1CUjYLyaRZCJOQlSxgZFnFKJpa
	kFxQnJReZKpXnJhbXJqXrpecn7uJEZgSTv97NnEH4/0D1ocYk4HxMZFZSjQ5H5hS8kriDY3N
	jCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqCz63rXWrLza
	xpUh5mvkig+WrzXWHt/zPnTqeY+WWlfPNi3Nb15ztNmSDvusX174zH36XeEEt8VmJVGhxfIb
	y1sDnF50hnc2arlOkzt85t3Gm1dza668Or9tw+OTnNo2LR6XEu7dT/l6JjnoT6+q/Cd+1vNN
	4hdCfkh93nrhzYU7PdsYxH4vVmIpzkg01GIuKk4EAFS4VBAfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t/t6bprX7sEGTz8pWBxedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jLe
	3ZnIWvBHt+LWtTksDYwPdLoYOTmEBNQkbn4+xAhiSwiYSPye+JwFwhaTuHBvPVsXIxdQzXxG
	iXm/OsGKWARUJZoO/mUDsdkEdCQ6/u9n7WLk4BAWKJL4uBmsV0RgBaPEvZ8JEPMVJa4tXQxW
	zisgKHFy5hOo+SoSh2dPYIWIq0q8a/0KFReXuDD3EjuEzSsxo/0pVFxOYtrXNcwQtrTE+Vkb
	GGHuXPz9MVScX+LY7R1MIOeA9D65HwwzZvfmL2wQtoDE1DMHoVo1JW4cWcwEYfNJrFn4lgVm
	zK5Ty5lheu9vmQtWwwz0ypTuh+wg45mBetfv0kf1FQeQ7Six9b7LBEbZWUgys5A0z0JoRlay
	gJFlFaNoakFyQXFSeoWxXnFibnFpXrpecn7uJkZw+nm2eAfj//PWhxgFOBiVeHgFMlyChFgT
	y4orcw8xSnAwK4nwro8FCvGmJFZWpRblxxeV5qQWH2JMBkbYRGYp0eR8YGrMK4k3NDY2MTMx
	tTSxMDA1J01YSZz3Wat1oJBAemJJanZqakFqEcwWJg5OqQbG4qCzWpar1xxV1qu9vftlVps9
	J5Py64lnbilev3S9/PSE76cPu62Ny9fZ2dnCJvdo+0SOB3b/6q94ih0Oj21nWWh23HGrs+/C
	WTfMpkYZx4o+uaM2bepfa7HQkL98j0titWW143afW7Yk1+OctXPk9Hns5YvulcrcXZl49KbG
	Vo6XEx5axiqrKbEUZyQaajEXFScCAPEx9cCDAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8R2Lx81019536

Hi,

>
>------- Original Message -------
>Sender : J. Bruce Fields<bfields@fieldses.org>
>Date : 2013-09-27 10:12 (GMT+09:00)
>Title : Re: Re: Re: Regression caused by commit 4bdc33ed ("NFSDv4.2: Add NFS v4.2 support to the NFS server")
>
>On Thu, Sep 26, 2013 at 11:57:57PM +0000, Jongman Heo wrote:
>> >------- Original Message -------
>> >Sender : J. Bruce Fields
>> >This is pretty weird--it's not at all obvious how that patch would
>> >affect this.
>> >
>> >You're absolutely positive that the *only* thing you're changing on the
>> >server between the "good" and "bad" cases is that one kernel patch?
>> >You're not changing anything in userspace?
>> >
>> 
>> Yes, pretty sure.
>> 
>> >What does "cat /proc/fs/nfsd/versions" report in the good and bad cases?
>> >
>> >(BTW, out of curiosity: what kind of client is this that only supports
>> >NFSv2 and NFSv3?  Even for an embedded system that's a bit surprising.)
>> >
>> >--b.
>> >
>> 
>> Here are /proc/fs/nfsd/versions information for good and bad cases ;
>> 
>> good (commit 4bdc33ed reverted)
>> 
>> # cat /proc/fs/nfsd/versions 
>> +2 +3 +4 +4.1
>> 
>> 
>> bad (current linus git)
>> 
>> # cat /proc/fs/nfsd/versions  
>> -2 +3 +4 +4.1 -4.2
>> 
>> 
>> I don't know why the commit 4bdc33ed makes this difference ( from +2 to -2 ).
>> 
>> My NFS server just uses Fedora 19 + latest kernel (which is not a rare setup...), 
>
>The thing is, nfs-utils *did* make exactly this change with commit
>6b4e4965a6b82e8d49cea1c0316b951ba4e9e83e "rpc.nfsd: No longer advertise
>NFS v2 support." in 1.2.9-rc4 which entered f19 recently.  And that
>kernel commit doesn't look related.  So I strongly suspect that you got
>the nfs-utils update (or rebooted after the update) at the same time as
>bisecting, and that confused the bisect results.
>

No, I haven't changed/upgraded nfs-utils package during git bisect.
And I can still reproduce the issue.

# rpm -qa|grep nfs-utils
nfs-utils-1.2.8-4.0.fc19.i686

# rpm -q --changelog nfs-utils|head -6
* Mon Aug 19 2013 Steve Dickson <steved@redhat.com> 1.2.8-4.0
- Updated to latest upstream RC release: nfs-utils-1-2-9-rc4

* Tue Jul 23 2013 Steve Dickson <steved@redhat.com> 1.2.8-3.0
- Updated to latest upstream RC release: nfs-utils-1-2-9-rc3

As you noticed, 1.2.9-rc4 is applied to Fedora 19's nfs-utils what I'm using...

With the nfs-utils, reverting the commit makes difference to me.


Another workaround from user-space (instead of revert) works for me.

Latest linus git gives following NFS version support (with my server's .config).

  # cat /proc/fs/nfsd/versions 
  -2 +3 +4 +4.1 -4.2

I've changed /etc/sysconfig/nfs file as following diff ;

@@ -10,7 +10,7 @@
 #LOCKD_UDPPORT=32769
 #
 # Optional arguments passed to rpc.nfsd. See rpc.nfsd(8)
-RPCNFSDARGS=""
+RPCNFSDARGS="-V 2"


Then. run nfs server again...

# systemctl restart nfs-server.service
# cat /proc/fs/nfsd/versions 
+2 +3 +4 +4.1 -4.2

Now NFS boot is working. 
Actually I'm OK with this, since NFS boot is just used for debugging purpose, not for production use, in my case.


FYI, in other Linux machine (Ubuntu 12.04), nfs-utils version is "1.2.5-3ubuntu3.1", and the kernel commit doesn't cause NFS v2 support issue.

# cat /proc/fs/nfsd/versions
+2 +3 +4 +4.1 -4.2

So, the change in nfs-utils 1.2.9-rc4 seems to be the root cause, but I don't know why the kernel commit revert resolves the issue.

>> so I think some people can verify if this version information change happens w/ and w/o the commit revert.
>> 
>> Don't know the detail of NFS protocol, but our NFS client seems not to try with v3 and v4 in case v2 fails...
>> Is this an unexpected (buggy) behavior of my old embedded box (NFS client of kernel 2.6.35), or expected one from the NFS protocol?
>
>Digging into a historical git repo just for fun.... It looks like NFSv3
>support was added in 2.3.99pre4-3, probably in 2000?  (The date on that
>commit is 2007, so obviously this repo I have is very confused.  Maybe I
>should go find if there's a better one someplace.)
>
>So anyway it's either configured out of the kernel or the mount
>commandline's asking for v2, or I don't know what....
>
>--b.
>

Thanks,
Jongman Heo.ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
