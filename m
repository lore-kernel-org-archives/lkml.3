Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaLJORg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:17:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52843 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbaLJORe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:17:34 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ca-548855fbc614
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Greg KH'" <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, casey@schaufler-ca.com,
        jlbec@evilplan.org, "'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        "'Rafal Krypa'" <r.krypa@samsung.com>,
        "'Tomasz Swierczek'" <t.swierczek@samsung.com>,
        "'Karol Lewandowski'" <k.lewandowsk@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Stanislaw Wadas'" <s.wadas@samsung.com>, kopasiak90@gmail.com,
        "=?iso-8859-2?Q?'=A3ukasz_Stelmach'?=" <l.stelmach@samsung.com>,
        "'Hillf Danton'" <hillf.zj@alibaba-inc.com>, chrisw@sous-sol.org,
        miklos@szeredi.hu
References: <022101d01309$09152b00$1b3f8100$%opasiak@samsung.com>
 <20141210045406.GB11973@kroah.com>
In-reply-to: <20141210045406.GB11973@kroah.com>
Subject: RE: VFS and LSM issues
Date: Wed, 10 Dec 2014 15:17:29 +0100
Message-id: <028f01d01484$08fd7010$1af85030$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAUNVcMHBxE2twlRAecGxHcP0+TqAAQYy2Q
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t/xa7q/QztCDHZ8NreY9bKdxeLetl9s
	Fr23lzBbNC9ez2Yxd/5hdouT576xWDR+msts8ex0nsXNQysYLS7vmsNm8aHnEZvFomWtzBZr
	j9xlt3i2eyOzxYLjLawWDw7vZLd4O2kFs8WyG5uYLH7dnsJqcf7vcVYHEY+Jbz+yeDy9GOSx
	c9Zddo/9c9ewe6z784rJo2/LKkaPo/sXsXls29PF7LFi2kUmj8+b5Dw2PXnLFMAdxWWTkpqT
	WZZapG+XwJVx5+At1oL1rhWdM7sZGxgvmHUxcnJICJhIbGnqZYKwxSQu3FvP1sXIxSEksJRR
	YuffdmYIp4FJ4sLJryxdjBwcbAL6EvN2iYI0iAg4SxzY+4gdpIZZYDWrxIWvO1hAEkICaRIz
	2y4yg9icQPWTJv4F2yAsIC9x6O0BRpA5LAKqEqef5oCEeQUcJdpvXmKDsAUlfky+B7aKWUBH
	4uukCJAws4C2xJN3F1hBwhIC6hKP/upCXGAkMXHLWjaIEhGJuw3PWScwCs1CMmgWwqBZSAbN
	QtKxgJFlFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIhH/dwbj0mNUhRgEORiUe3h2KbSFC
	rIllxZW5hxglOJiVRHjfSHaECPGmJFZWpRblxxeV5qQWH2Jk4uCUamAsvBOgd9Ajyjuynb0v
	9P3OXMZmAZ5kzYmuwWV+MwU0rfR2HZX2ChNgiV15ZcM7Scaav5FOe8JCDxrpCDf+eeZ06SQT
	2+25ifwt1ikpL5bcu+F3Zifjsw93/9yd8ibdfMuVymzuiyKrL5fzmrC+Zftka/bEefrb/YZt
	fLFhS8Tf5W3dI21+n0GJpTgj0VCLuag4EQASMOJhzgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, December 10, 2014 5:54 AM
> To: Krzysztof Opasiak
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> security-module@vger.kernel.org; casey@schaufler-ca.com;
> jlbec@evilplan.org; 'Andrzej Pietrasiewicz'; 'Michal Nazarewicz';
> 'Robert Baldyga'; Rafal Krypa; Tomasz Swierczek; 'Karol
> Lewandowski'; 'Marek Szyprowski'; 'Stanislaw Wadas';
> kopasiak90@gmail.com; '£ukasz Stelmach'
> Subject: Re: VFS and LSM issues
> 
> On Mon, Dec 08, 2014 at 06:04:30PM +0100, Krzysztof Opasiak wrote:
> > Dear All,
> >
> > I'm Krzysztof Opasiak from SRPOL (Samsung). I'm working on USB
> support
> > in Tizen and mainline. In those works we use two Virtual File
> Systems
> > - ConfigFS and FunctionFS. Recently I have tried to use them with
> > SMACK and I ran into a few issues. Most of them looks to be a
> generic
> > problem with many FS and LSM. You can find description of those
> issues
> > and my research just below in 3 points. I'm not a VFS/LSM
> specialist so
> > your help is very welcome;)
> >
> > 1) Issues with function FS
> >
> > It's a VFS which allow to provide custom USB function as
> userspace
> > program. I know that may be quite new for you so let's define
> this as
> > a VFS which works as follow:
> >
> > $ modprobe g_ffs
> > $ mkdir /tmp/mount_root
> > $ mount none -t functionfs /tmp/mount_root
> > $ ls /tmp/mount_root
> > ep0
> >
> > # now we run our program which writes some data to ep0
> > #  and based on this kernel creates epX
> > # you can find one in tools/usb/ffs-test.c
> >
> > $ ./my_program /tmp/mount_root &
> > $ ls /tmp/mount_root
> > ep0 ep1 ep2
> >
> > Ok so now we would like to use this together with smack.
> Especially
> > with smackfsdef mount option. First two steps go as above and
> then:
> >
> > $ mount none -t functionfs -o smackfsdef=my_label /tmp/mount_root
> > $ ls -Z /tmp/mount_root/
> >  _ ep0
> >
> > Ops! Some bug here we requested to use my_label but we got _.
> When we
> > run our program, rest of epX will get desired label (my_label). I
> have
> > started to dig in kernel to find what happen and probably I found
> out
> > where is a problem. Let's look to mount_fs() code which is
> executed
> > during mount:
> >
> > struct dentry *
> > mount_fs(struct file_system_type *type, int flags, const char
> *name,
> > void *data)
> > {
> > (...)
> > 	root = type->mount(type, flags, name, data);
> > (...)
> > 	error = security_sb_kern_mount(sb, flags, secdata);
> > (...)
> > }
> >
> > So what is important here is the order of operations. First is
> > executed mount ops provided by selected file system. During this
> mount
> > procedure functionfs executes new_inode(sb) to allocate inode for
> ep0
> > which should appear directly after mount. After returning from
> mount
> > function we execute security_sb_kern_mount() where we *parse the
> mount
> > options* and sets the value for lsm specific structures for
> example we
> > store the label passed in smackfsdef.
> >
> > The problem here is order of calls because first we call mount
> for
> > given fs where we create a file and after this we fill security
> > structures with security mount options. While creating file in
> mount
> > callback super block is filled only with default values for
> security
> > so ep0 has _ label. This looks like a generic issue for all VFS
> which
> > creates indoes before or in their mount procedure.
> >
> > I'm not sure if we can simply move security_sb_kern_mount() above
> > mount for specific fs, do we?
> 
> No, I do not think you can, sorry.

That was also my opinion.

> 
> > 2) Issues with ConfigFS
> >
> > ConfigFS is a generic VFS which allows to create and manage
> kobjects
> > from userspace. Each module which would like to allow for
> userland
> > driven configuration register as ConfigFS client called
> > subsystem. Each subsystem has its own directory in ConfigFS root
> > dir. We use libcomposite which appear in ConfigFS as usb_gadget
> > directory. In this dir you can create directories called gadgets.
> Some
> > example:
> >
> > # libcomposite and configfs compiled-in
> > $ mount none -t configfs /sys/kernel/config
> > $ ls /sys/kernel/config usb_gadget
> > $ mkdir /sys/kernel/config/usb_gadget/g1
> > $ ls /sys/kernel/config/usb_gadget/g1
> > UDC              bDeviceSubClass  bcdUSB     idProduct  strings
> > bDeviceClass     bMaxPacketSize0  configs    idVendor
> > bDeviceProtocol  bcdDevice        functions  os_desc
> >
> >
> > Now let's try to use smack with ConfigFS. First of all we run to
> > similar issue as with FunctionFS so after mounting configfs with
> > smackfsdef option we still get _ label on subsystem directories
> > because they are created in configfs_register_subsystem() which
> is
> > called in libcomposite module init so really erly. So in my
> opinion
> > this looks quite similar to issue described in functionfs
> section.
> 
> Yes, "virtual" filesystems like these haven't probably ever been
> tested
> with an LSM before, as you are finding out.

Yes, I agree. I have done some more digging recently and I think that
it's conceptual problem in dcache.h API. Thanks to Hillf Danton who
asked me if I use kdbus I found out that kdbus is now also using
separate file system (kdbusfs) and has a control file just after
mount. I thought that this issue is also there but it's not.

I started to study kdbusfs implementation [1] to find out why it works
as desired. I found out that kdbusfs is not using most of dcache.h
API. Functionfs don't care about inodes for directories and just use
d_make_root() in mount and d_add() for creating a file. In kdbus
everything is done by itself. It means that it provides inode ops for
all indoes also for directories. There is no d_add() call while
creating a new file. New file is being created only as inode and then
in fs_dir_iop_lookup(), which is provided as lookup callback in
inode_operations, kdbus calls d_materialise_unique(). This means that
security label for file is initialized on first lookup in root dir
when all security flags from mount are parsed and properly stored in
super block. I think that it's why it works properly in kdbusfs.

I have no idea how to solve this. Re writing all VFS's to provide
inode operations and store only inodes instead of dentries, like
kdbusfs does, will make their code much more complicated and it's a
lot of work to be done. On the other hand I don't see an easy way how
this could be fixed in a generic way in lower layer. Maybe VFS
maintainer has some idea how to fix this?

> 
> > Second issue related to Configfs is when we create the directory.
> > Reproduction:
> >
> > $ mount none -t configfs -o smackfsdef=my_label
> /sys/kernel/config
> > $ ls -Z /sys/kernel/config
> > _ usb_gadget
> > $ chmod 777 /sys/kernel/config/usb_gadget
> > $ chsmack -a my_label /sys/kernel/config/usb_gadget
> > $ echo my_label > /proc/self/attr/current
> > $ su my_user
> > $ mkdir /sys/kernel/config/usb_gadget/g1
> > $ ls -Z /sys/kernel/config/usb_gadget/
> > _ g1
> >
> > As you see our process had my_label label but created by him
> gadget
> > has the _ label and the same with all files and subdirs created
> in
> > g1. I have no idea why this happened but definetly something is
> > wrong. Related to this is a policy of labeling subdirectories.
> Obvious
> > thing is that g1 directory should have label different that _.
> But I'm
> > not shure what label should have its children.
> >
> > 3) Generic question with multi mounts filesystems
> >
> > Some VFS (ConfigFS for example) can be mounted more than once.
> What
> > should be the correct behavior of smackfsdef mount option if we
> pass
> > different labels in each mount point?
> 
> How would it be different from a "normal" filesystem you mount at
> different locations?
> 

Normal file system will have most of labels set properly and stored in
block device as xattrs in VFS most those xattrs are stored in memory
so a lot of labels is not initialized. The question is more like: If
we can mount file system in one place as RW and in other place as RO
could we do the same with smack labels? Can we mount fs with
smackfsdef=label1 and smackfsdef=label2 in other place? How we should
understand such mount? Which label should be used? First one or last
one?

> good luck!

Thank you, I see that it will be needed;)

Footnotes:
1 - git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
branch kdbus

--
Best regards,
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com




