Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602Ab3GSQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:45:31 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:24137 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3GSQp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:45:29 -0400
X-AuditID: cbfec37b-b7f306d0000047de-7e-51e96d277709
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/38] 3.9.11-stable review
Thread-topic: [ 00/38] 3.9.11-stable review
Thread-index: AQHOhJVmEYdPFGTrWEWBmR0E5HnPIQ==
Date: Fri, 19 Jul 2013 16:45:25 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174192D@sisaex01sj>
References: <20130719052047.858393825@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wr6567stAg5WrDC3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrY3HSTveA0b8WXm5uYGhhncXcxcnJICJhIXP92mhXCFpO4cG89WxcjF4eQwDJGiefP
	DjNBOL1MEv/+L2cGqRISmM8oMalTAsRmE1CX+Px6BzuILSJgLNF/dhaYzSxwjEmio7MMxBYW
	0JK4vPccC0SNtsT/D+/ZIGw9iXtzbgFt5uBgEVCVuLBTHiTMK2AvcW3dIUaIVVYSmzaeBxvJ
	CHTc91NrmCDGi0s0t95kgThaQGLJnvPMELaoxMvH/8BGSggoSmxfbQVRrifx8c9tRghbW+LJ
	uwusEKsEJX5MvscygVFsFpKps5C0zELSMgtJywJGllWMYqXFyQXFSempFUZ6xYm5xaV56XrJ
	+bmbGCFxV72D8e5Xm0OMAhyMSjy8D748DxRiTSwrrsw9xCjBwawkwluQ9jJQiDclsbIqtSg/
	vqg0J7X4ECMTB6dUA6N3icOSAMa1Lcaq0nlL//98aRTfxq7lKDHjgbDshKRoWR1X7WuT6tNd
	//83dHIpWPJs9k83tlV///w//O/tA9M1lv0Oc+ReWD+flXN7492E1ylbbT6w9q6dXxgeXbeS
	v/TdlOjzaQlme4X2+0tv2SY06+jayykb7NbW/7gs9O3E6v61uhz+NZuVWIozEg21mIuKEwGG
	xJl+mQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 09:34 AM, Greg Kroah-Hartman wrote:
> ---------------
> Note, this is the LAST 3.9-stable kernel release that I will be doing.
> Please move to the 3.10-stable branch as soon as possible.
> ---------------
>
> This is the start of the stable review cycle for the 3.9.11 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 21 05:20:01 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.11-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Greg,

Build failed with the following error:

   LD      ipc/built-in.o
   CC [M]  fs/cifs/inode.o
fs/cifs/inode.c: In function ‘cifs_all_info_to_fattr’:
fs/cifs/inode.c:560:4: error: implicit declaration of function 
‘cifs_dbg’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [fs/cifs/inode.o] Error 1
make[1]: *** [fs/cifs] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....
   CC      security/selinux/hooks.o

I have CONFIG_CIFS=m in my config and CONFIG_CIFS_DEBUG is disabled. 
cifs_dbg() is not defined.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
